class LimitScopesController < ApplicationController
  def index
    @role = Role.find(params[:role_id])
    @permission = Permission.find(params[:permission_id])
    @klass = @permission.klasses.find(params[:klass_id]) if params[:klass_id]
    @limit_scopes = @klass ? @role.limit_scopes.for_permission(@permission).all : []

    respond_to do |format|
      format.html
      format.xml  { render :xml => @limit_scopes }
    end
  end

  def create
    @limit_scope = LimitScope.new(params[:limit_scope])

    respond_to do |format|
      if @limit_scope.save
        flash[:notice] = 'Limit scope was successfully created.'
        format.html { redirect_to(:back) }
        format.xml  { render :xml => @limit_scope, :status => :created, :location => @limit_scope }
      else
        raise @limit_scope.errors.inspect
        format.html { render :action => "index" }
        format.xml  { render :xml => @limit_scope.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @limit_scope = LimitScope.find(params[:id])

    respond_to do |format|
      if @limit_scope.update_attributes(params[:limit_scope])
        flash[:notice] = 'Limit scope was successfully updated.'
        format.html { redirect_to(:back) }
        format.xml  { head :ok }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @limit_scope.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @limit_scope = LimitScope.find(params[:id])
    @limit_scope.destroy

    respond_to do |format|
      format.html { redirect_to(:back) }
      format.xml  { head :ok }
    end
  end

  def suggest_key_meta
    meta = Meta.find(params[:key_meta_id])
    @values = meta.assoc_klass.metas.all.map{|m|[m.name, m.id]} if meta.assoc_klass
    render :inline => "<%=select 'limit_scope', 'key_meta_id', @values if @values%>"
  end

end
