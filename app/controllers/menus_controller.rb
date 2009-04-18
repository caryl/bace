class MenusController < ApplicationController
  def index
    @menus = Menu.find(:all)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @menus }
    end
  end

  def show
    @menu = Menu.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @menu }
    end
  end

  def new
    @menu = Menu.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @menu }
    end
  end

  def edit
    @menu = Menu.find(params[:id])
  end

  def create
    @menu = Menu.new(params[:menu])

    respond_to do |format|
      if @menu.save
        @menu.move_to_child_of(params[:menu][:parent_id]) if params[:menu][:parent_id].present?

        flash[:notice] = 'Menu was successfully created.'
        format.html { redirect_to(@menu) }
        format.xml  { render :xml => @menu, :status => :created, :location => @menu }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @menu.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @menu = Menu.find(params[:id])

    respond_to do |format|
      if @menu.update_attributes(params[:menu])
        @menu.move_to_child_of(params[:menu][:parent_id]) if params[:menu][:parent_id].present?

        flash[:notice] = 'Menu was successfully updated.'
        format.html { redirect_to(@menu) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @menu.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @menu = Menu.find(params[:id])
    @menu.destroy

    respond_to do |format|
      format.html { redirect_to(menus_url) }
      format.xml  { head :ok }
    end
  end
end
