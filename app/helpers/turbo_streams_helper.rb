module TurboStreamsHelper

  def turbo_stream_update(element, partial, locals = {})
    turbo_stream.update(element, partial: partial, locals: locals)
  end
end