shared_examples_for 'Create object in database' do
  it 'saves a new object in the database' do
    expect { post :create, params: params, format: :js }.to change(object, :count).by(1)
  end
end

shared_examples_for 'Render create template' do
  it 'renders create template' do
    post :create, params: params, format: :js
    expect(response).to render_template :create
  end
end

shared_examples_for 'Render destroy template' do
  it 'renders destroy view' do
    delete :destroy, params: params, format: :js
    expect(response).to render_template :destroy
  end
end

