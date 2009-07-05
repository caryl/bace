class LimitGroupsController < ApplicationController
  def index
    @klass = Klass.find(params[:klass_id])
    @limit_groups = @klass.limit_groups.find(:all)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @limit_groups }
    end
  end

  def show
    @limit_group = LimitGroup.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @limit_group }
    end
  end

  def new
    @klass = Klass.find(params[:klass_id])
    @limit_group = LimitGroup.new(:klass => @klass, :parent_id => params[:parent_id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @limit_group }
    end
  end

  def edit
    @limit_group = LimitGroup.find(params[:id])
    @klass = @limit_group.klass
  end

  def create
    @limit_group = LimitGroup.new(params[:limit_group])

    respond_to do |format|
      if @limit_group.save
        @limit_group.move_to_child_of(params[:limit_group][:parent_id]) if params[:limit_group][:parent_id].present?
        flash[:notice] = 'Limit group was successfully created.'
        format.html { redirect_to(@limit_group) }
        format.xml  { render :xml => @limit_group, :status => :created, :location => @limit_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @limit_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @limit_group = LimitGroup.find(params[:id])

    respond_to do |format|
      if @limit_group.update_attributes(params[:limit_group])
        @limit_group.move_to_child_of(params[:limit_group][:parent_id]) if params[:limit_group][:parent_id].present?
        flash[:notice] = 'Limit group was successfully updated.'
        format.html { redirect_to(@limit_group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @limit_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @limit_group = LimitGroup.find(params[:id])
    @limit_group.destroy

    respond_to do |format|
      format.html { redirect_to(klass_limit_groups_url(@limit_group.klass_id)) }
      format.xml  { head :ok }
    end
  end
end
