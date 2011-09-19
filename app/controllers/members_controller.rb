class MembersController < ApplicationController

  before_filter :find_all_members
  before_filter :find_page

  def index
    redirect_to root_url
  end

  def show
    redirect_to root_url
  end

protected

  def find_all_members
    @members = Member.order('position ASC')
  end

  def find_page
    @page = Page.where(:link_url => "/members").first
  end

end
