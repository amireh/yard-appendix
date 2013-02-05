def init
  super
  sections :appendix, [ :appendix_entry, [ T('docstring')] ]
end

def appendix
  unless @appendixes
    return if !object.respond_to?(:type) || !object.is_a?(YARD::CodeObjects::Base) || object.type == :appendix
  end

  @appendixes ||= object.children.select { |o| o.type == :appendix }
  
  return if @appendixes.empty?
  
  log.info "yard-appendix: found #{@appendixes.count} appendix entries for #{object}"
  
  erb :listing
end

def appendix_entry
  return unless object.type == :appendix
  
  log.info "yard-appendix: rendering appending entry #{object.title}"
  
  erb :entry
end