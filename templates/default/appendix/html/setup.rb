def init
  super
  sections :appendix, [ :appendix_entry, [ T('docstring')] ]
end

def appendix
  return if object.type == :appendix

  @appendixes = object.children.select { |o| o.type == :appendix }
  
  return if @appendixes.empty?
  
  log.debug "yard-appendix: found #{@appendixes.count} appendix entries for #{object}"
  
  erb :listing
end

def appendix_entry
  return unless object.type == :appendix
  
  erb :entry
end