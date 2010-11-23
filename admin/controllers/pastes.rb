Admin.controllers :pastes do

  get :index do
    @pastes = Paste.all
    render 'pastes/index'
  end

  get :new do
    @paste = Paste.new
    render 'pastes/new'
  end

  post :create do
    @paste = Paste.new(params[:paste])
    if @paste.save
      flash[:notice] = 'Paste was successfully created.'
      redirect url(:pastes, :edit, :id => @paste.id)
    else
      render 'pastes/new'
    end
  end

  get :edit, :with => :id do
    @paste = Paste.find(params[:id])
    render 'pastes/edit'
  end

  put :update, :with => :id do
    @paste = Paste.find(params[:id])
    if @paste.update_attributes(params[:paste])
      flash[:notice] = 'Paste was successfully updated.'
      redirect url(:pastes, :edit, :id => @paste.id)
    else
      render 'pastes/edit'
    end
  end

  delete :destroy, :with => :id do
    paste = Paste.find(params[:id])
    if paste.destroy
      flash[:notice] = 'Paste was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Paste!'
    end
    redirect url(:pastes, :index)
  end
end