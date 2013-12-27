module ApplicationHelper
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  def paginate(collection, params= {})
    will_paginate collection, params.merge(:renderer => RemoteLinkPaginationHelper::LinkRenderer)
  end    
end
