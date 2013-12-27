class SchoolsController < ApplicationController
  before_filter :set_school, only: [:edit, :update, :destroy]
  require 'will_paginate/array'
  # GET /schools
  # GET /schools.json
  def index
    @o_single = School.new
    
    items_per_page = 2
    
    if params[:page]
      page_count = params[:page].to_i
      total_limit = page_count * items_per_page
      session[:total_limit] = total_limit
    else
      page_count = 1
      total_limit = page_count * items_per_page
      session[:total_limit] = session[:total_limit] ? session[:total_limit] : total_limit 
    end    
    
    school_query = School.order("id desc")
    
    if params[:school]
      params[:page] = params[:page] ? params[:page] : 1
      school_query = School.limit(session[:total_limit].to_i).order("id desc").all
      school_query = school_query.select {|s| s.name.include? params[:school][:name]}
    end
    
    if !params[:page] and !params[:school]
      session[:total_limit] = nil
    end
    
    @schools = school_query.paginate(:page => params[:page])
    

  end
  
  def add_to_listing
    @schools = School.paginate(:page => params[:page]).order("id desc")
    respond_to do |format|
      format.html # renders show.html.erb
      format.js   # renders show.js.erb
    end    
  end  

  # GET /schools/new
  # GET /schools/new.json
  def new
    @o_single = School.new
  end

  # GET /schools/1/edit
  def edit
    #@o_single = School.find(params[:id])
  end

  # POST /schools
  # POST /schools.json
  def create
    @o_single = School.new(school_params)
    flash[:notice] = nil
    if @o_single.save
      flash[:notice] = 'School was successfully created.'
    end
  end

  # PUT /schools/1
  # PUT /schools/1.json
  def update
    @o_single = School.find(params[:id])
    flash[:notice] = nil
    if @o_single.update_attributes(school_params)
      flash[:notice] = 'School was successfully updated.'
    end    
  end

  # DELETE /schools/1
  # DELETE /schools/1.json
  def destroy
    #@o_single = School.find(params[:id])
    @o_single.destroy
    flash[:notice] = 'School was successfully deleted.'
    @schools = School.order("id desc")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school
      @o_single = School.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def school_params
      params.require(:school).permit!
    end
end
