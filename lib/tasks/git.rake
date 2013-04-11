# Rake tasks related to Git

namespace :git do

  desc "Run \"git pull\" and update virtual machines"
  task :update do
    if git_update
      vagrant_up(boxes)
      vagrant_provision(boxes)
    end
  end

end

def git_update
  old_head = `git rev-parse HEAD`
  #unless system('git fetch && git reset origin/master && git clean -ffd && git reset --hard >/dev/null && git submodule update --init')
  unless system('git pull --ff-only && git clean -ffd && git submodule update --init')
    raise "Failed to update Git repository; last exit status was #{$?.exitstatus}"
  end
  new_head = `git rev-parse HEAD`
  return old_head != new_head
end
