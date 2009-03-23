class KlassesController < ApplicationController
  def index
    @klasses = Klass.find(:all)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @klasses }
    end
  end

  def show
    @klass = Klass.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @klass }
    end
  end

  def new
    @klass = Klass.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @klass }
    end
  end

  def edit
    @klass = Klass.find(params[:id])
  end

  def create
    @klass = Klass.new(params[:klass])

    respond_to do |format|
      if @klass.save
        flash[:notice] = 'Klass was successfully created.'
        format.html { redirect_to(@klass) }
        format.xml  { render :xml => @klass, :status => :created, :location => @klass }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @klass.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @klass = Klass.find(params[:id])

    respond_to do |format|
      if @klass.update_attributes(params[:klass])
        flash[:notice] = 'Klass was successfully updated.'
        format.html { redirect_to(@klass) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @klass.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @klass = Klass.find(params[:id])
    @klass.destroy

    respond_to do |format|
      format.html { redirect_to(klasses_url) }
      format.xml  { head :ok }
    end
  end
end
