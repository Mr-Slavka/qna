require "rails_helper"

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe "GET #new" do
    before { get :new, params: { question_id: question } }

    it "renders new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    before { login(user) }

    context "with valid attributes" do
      it "Authenticated user saves a new answer in the database" do
        expect { post :create, params: {question_id: question, answer: attributes_for(:answer)}, format: :js }.to change(question.answers, :count).by(1)
      end

      it "renders create template" do
        post :create, params: {question_id: question, answer: attributes_for(:answer), format: :js}
        expect(response).to render_template :create
      end
    end

    context "with invalid attributes" do
      it "Authenticated user does not save the answer" do
        expect { post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }.to_not change(question.answers, :count)
      end

      it "re-render new view" do
        post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid), format: :js}
        expect(response).to render_template :create
      end
    end
  end

  describe "DELETE #destroy" do
    before { login(user) }

    let!(:question) { create(:question, user: user) }
    let!(:other_user) { create(:user) }
    let!(:other_answer) { create(:answer, question: question, user: other_user) }

    context "Authorized user" do
      let!(:answer) { create(:answer, question: question, user: user) }
      it "deletes the answer" do

        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it "render view destroy" do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "Authorized other user" do
      let!(:answer) { create(:answer, question: question, user: user) }

      it "deletes the answer" do

        expect { delete :destroy, params: { id: other_answer }, format: :js }.to_not change(Answer, :count)
      end

      it "render view destroy" do
        delete :destroy, params: { id: other_answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe "PATCH #update" do
    let!(:answer) { create(:answer, question: question) }

    context "with valid attributes" do
      it "changes answer attributes" do
        patch :update, params: { id: answer, answer: { body: "new body"} }, format: :js
        answer.reload
        expect(answer.body).to eq "new body"
      end

      it "renders update view" do
        patch :update, params: { id: answer, answer: { body: "new body"} }, format: :js
        expect(response).to render_template :update
      end
    end

    context "with invalid attributes" do
      it "does not change answer attributes" do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it "renders update view" do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe "POST #mark_as_best" do
    it "mark best answer" do
      post :mark_as_best, params: { id: answer }, format: :js
      expect(assigns(:answer)).to be_best
    end
  end
end
