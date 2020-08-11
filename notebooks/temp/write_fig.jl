# using Plots

function dev_pdf(fn::AbstractString)
  fn = Plots.addExtension(fn, "pdf")
  io = open(fn, "a")
#   close(io)
end

dev_off(io) = close(io)
# pdf(fn::AbstractString) = pdf(current(), fn)

function write_fig2(ps, fn::AbstractString)
  fn = abspath(expanduser(fn))
  # get the extension
  local ext
  try
    ext = Plots.getExtension(fn)
  catch
    # if we couldn't extract the extension, add the default
    ext = defaultOutputFormat(plt)
    fn = addExtension(fn, ext)
  end

  # save it
#   func = get(_savemap, ext) do
#     error("Unsupported extension $ext with filename ", fn)
#   end
  io = dev_pdf(fn)
  for p in ps; show(io, MIME("application/pdf"), p); end
  dev_off(io)
  nothing
#   func(plt, fn)
end
# savefig(fn::AbstractString) = savefig(current(), fn)
