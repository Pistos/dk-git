git_proc = Proc.new do |buffer|
  if buffer && buffer.name
    dir = File.dirname( File.expand_path( buffer.name ) )
  else
    dir = '.'
  end

  if File.exist? dir
    branch = Dir.chdir( dir ){ `git symbolic-ref HEAD 2>/dev/null`[ /[^\/\n]+$/ ] }
    if branch
      width_max = $diakonos.main_window_width / 4
      branch_truncated = branch[0..width_max]
      if branch_truncated != branch
        branch = branch_truncated[0...-2] << '..'
      end
    end
    $diakonos.set_status_variable(
      '@git_branch',
      branch ? " git:#{branch} " : nil
    )
  end
end

$diakonos.register_proc( git_proc, :after_open )
$diakonos.register_proc( git_proc, :after_buffer_switch )
