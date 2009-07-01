class LimitGroupsController < ApplicationController
  def index
    @limit_groups = LimitGroup.find(:all)

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
    @limit_group = LimitGroup.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @limit_group }
    end
  end

  def edit
    @limit_group = LimitGroup.find(params[:id])
  end

  def create
    @limit_group = LimitGroup.new(params[:limit_group])

    respond_to do |format|
      if @limit_group.save
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
      format.html { redirect_to(limit_groups_url) }
      format.xml  { head :ok }
    end
  end
end
