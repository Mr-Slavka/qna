require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:request_method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it_behaves_like 'Resource count returnable' do
          let(:resource_response) { question_response['answers'] }
          let(:resource) { answers }
        end

        it_behaves_like 'Public fields returnable' do
          let(:resource) { answer }
          let(:resource_response) { answer_response }
          let(:attrs) { %w[id body created_at updated_at] }
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, :question_files, user: user) }
    let(:question_response) { json['question'] }
    let!(:comments) { create_list(:comment, 2, question_id: question.id, user: user) }
    let!(:links) { create_list(:link, 2, question_id: question.id) }
    let(:access_token) { create(:access_token) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:request_method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it_behaves_like 'Success requestable'

    it_behaves_like 'Public fields returnable' do
      let(:attrs) { %w[id title body created_at updated_at] }
      let(:resource_response) { question_response }
      let(:resource) { question }
    end

    describe 'comments' do
      it_behaves_like 'Resource count returnable' do
        let(:resource_response) { question_response['comments'] }
        let(:resource) { comments }
      end
    end

    describe 'links' do
      it_behaves_like 'Resource count returnable' do
        let(:resource_response) { question_response['links'] }
        let(:resource) { links }
      end
    end

    describe 'files' do
      it_behaves_like 'Resource count returnable' do
        let(:resource_response) { question_response['files'] }
        let(:resource) { question.files }
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:request_method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      context 'with valid attributes' do
        it 'saves a new question' do
          expect { post api_path, params: { question: attributes_for(:question),
                                            access_token: access_token.token } }.to change(Question, :count).by(1)
        end

        it 'returns status :created' do
          post api_path, params: { question: attributes_for(:question), access_token: access_token.token }
          expect(response.status).to eq 201
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post api_path, params: { question: attributes_for(:question, :invalid),
                                            access_token: access_token.token } }.to_not change(Question, :count)
        end

        it 'returns status :unprocessible_entity' do
          post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token }
          expect(response.status).to eq 422
        end

        it 'returns error message' do
          post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token }
          expect(json['errors']).to be
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:request_method) { :delete }
    end

    context 'authorized' do
      context 'delete the question' do
        let(:params) do
          { access_token: access_token.token,
            question_id: question }
        end

        before { delete api_path, headers: headers, params: params }

        it_behaves_like 'Success requestable'

        it 'delete the question' do
          expect(Question.count).to eq 0
        end

        it 'return message' do
          expect(json['messages']).to include "Question was successfully deleted"
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:edit_question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{edit_question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:request_method) { :patch }
    end

    context 'authorized' do
      context 'with valid attributes' do
        before { patch api_path,  params: { id: edit_question.id, question: { title: 'new title', body: 'new body'}, access_token: access_token.token } }

        it_behaves_like 'Success requestable'

        it 'changes question attributes' do
          edit_question.reload

          expect(edit_question.title).to eq 'new title'
          expect(edit_question.body).to eq 'new body'
        end
      end
    end

    context 'not an author tries to update question' do
      let(:other_user) { create(:user) }
      let(:other_question) { create(:question, user: other_user) }
      let(:other_api_path) { create("/api/v1/questions/#{other_question.id}") }

      before { patch api_path,  params: { id: other_question, question: { title: 'new title', body: 'new body'}, access_token: access_token.token } }

      it 'can not change question attributes' do
        other_question.reload

        expect(other_question.title).to eq other_question.title
        expect(other_question.body).to eq other_question.body
      end
    end
  end
end
