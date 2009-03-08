class LimitScopesController < ApplicationController
  def index
    @limit_scopes = LimitScope.find(:all)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @limit_scopes }
    end
  end

  def show
    @limit_scope = LimitScope.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @limit_scope }
    end
  end

  def new
    @limit_scope = LimitScope.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @limit_scope }
    end
  end

  def edit
    @limit_scope = LimitScope.find(params[:id])
  end

  def create
    @limit_scope = LimitScope.new(params[:limit_scope])

    respond_to do |format|
      if @limit_scope.save
        flash[:notice] = 'Limit scope was successfully created.'
        format.html { redirect_to(@limit_scope) }
        format.xml  { render :xml => @limit_scope, :status => :created, :location => @limit_scope }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @limit_scope.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @limit_scope = LimitScope.find(params[:id])

    respond_to do |format|
      if @limit_scope.update_attributes(params[:limit_scope])
        flash[:notice] = 'Limit scope was successfully updated.'
        format.html { redirect_to(@limit_scope) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @limit_scope.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @limit_scope = LimitScope.find(params[:id])
    @limit_scope.destroy

    respond_to do |format|
      format.html { redirect_to(limit_scopes_url) }
      format.xml  { head :ok }
    end
  end
end
