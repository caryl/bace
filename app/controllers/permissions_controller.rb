class PermissionsController < ApplicationController
  def index
    @permissions = Permission.paginate(:order => 'lft', :page => params[:page]||1)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @permissions }
    end
  end

  def show
    @permission = Permission.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @permission }
    end
  end

  def new
    @permission = Permission.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @permission }
    end
  end

  def edit
    @permission = Permission.find(params[:id])
  end

  def create
    @permission = Permission.new(params[:permission])
    respond_to do |format|
      if @permission.save
        @permission.move_to_child_of(params[:permission][:parent_id]) if params[:permission][:parent_id].present?
        flash[:notice] = 'Permission was successfully created.'
        format.html { redirect_to(@permission) }
        format.xml  { render :xml => @permission, :status => :created, :location => @permission }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @permission.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @permission = Permission.find(params[:id])
    respond_to do |format|
      if @permission.update_attributes(params[:permission])
        @permission.move_to_child_of(params[:permission][:parent_id]) if params[:permission][:parent_id].present?
        flash[:notice] = 'Permission was successfully updated.'
        format.html { redirect_to(@permission) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @permission.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @permission = Permission.find(params[:id])
    @permission.destroy

    respond_to do |format|
      format.html { redirect_to(permissions_url) }
      format.xml  { head :ok }
    end
  end

  def edit_klasses
    @permission = Permission.find(params[:id])
  end

  def change_klasses
    @permission = Permission.find(params[:id])
    klasses = params[:klass] ? Klass.find(params[:klass].keys) : []
    respond_to do |format|
      if @permission.klasses.replace klasses
        flash[:notice] = 'Permission klasses was successfully updated.'
        format.html { redirect_to(@permission) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit_klasses" }
        format.xml  { render :xml => @permission.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit_metas
    @permission = Permission.find(params[:id], :include => :klasses)
    @metas = Meta.all(:conditions => {:klass => @permission.klasses})
  end

  def change_metas
    @permission = Permission.find(params[:id])
    metas = params[:meta] ? Meta.find(params[:meta].keys) : []
    respond_to do |format|
      if @permission.metas.replace metas
        flash[:notice] = 'Permission meta was successfully updated.'
        format.html { redirect_to(@permission) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit_metas" }
        format.xml  { render :xml => @permission.errors, :status => :unprocessable_entity }
      end
    end
  end
end
