require 'fileutils'
# file operations needs to be relative to this file
VAGRANT_ROOT = File.dirname(File.expand_path(__FILE__))

# directory that will contain VDI files
VAGRANT_DISKS_DIRECTORY = "disks"

# controller definition
VAGRANT_CONTROLLER_NAME = "Virtual I/O Device SCSI controller"
VAGRANT_CONTROLLER_TYPE = "virtio-scsi"

# define disks
# The format is filename, size (GB), port (see controller docs)
local_disks = [
 # { :filename => "disk1", :size => 5, :port => 5 },
 # { :filename => "disk2", :size => 5, :port => 6 },
  { :filename => "disk3", :size => 10, :port => 25 }
]

# Describe VMs
MACHINES = {
  # VM name "kernel update"
  :"kernel-update" => {
              # VM box
              :box_name => "centos/7",
              # VM CPU count
              :cpus => 4,
              # VM RAM size (Mb)
              :memory => 4098,
              # networks
              :net => [],
              # forwarded ports
              :forwarded_port => []
            }
}

Vagrant.configure("2") do |config|
  disks_directory = File.join(VAGRANT_ROOT, VAGRANT_DISKS_DIRECTORY)

  # create disks before "up" action
  config.trigger.before :up do |trigger|
    trigger.name = "Create disks"
    trigger.ruby do
      unless File.directory?(disks_directory)
        FileUtils.mkdir_p(disks_directory)
      end
      local_disks.each do |local_disk|
        local_disk_filename = File.join(disks_directory, "#{local_disk[:filename]}.vdi")
        unless File.exist?(local_disk_filename)
          puts "Creating \"#{local_disk[:filename]}\" disk"
          system("vboxmanage createmedium --filename #{local_disk_filename} --size #{local_disk[:size] * 1024} --format VDI")
        end
      end
    end
  end

  # create storage controller on first run
  unless File.directory?(disks_directory)
    config.vm.provider "virtualbox" do |storage_provider|
      storage_provider.customize ["storagectl", :id, "--name", VAGRANT_CONTROLLER_NAME, "--add", VAGRANT_CONTROLLER_TYPE, '--hostiocache', 'off']
    end
  end

  # attach storage devices
  config.vm.provider "virtualbox" do |storage_provider|
    local_disks.each do |local_disk|
      local_disk_filename = File.join(disks_directory, "#{local_disk[:filename]}.vdi")
      unless File.exist?(local_disk_filename)
        storage_provider.customize ['storageattach', :id, '--storagectl', VAGRANT_CONTROLLER_NAME, '--port', local_disk[:port], '--device', 0, '--type', 'hdd', '--medium', local_disk_filename]
      end
    end
  end

  # cleanup after "destroy" action
  config.trigger.after :destroy do |trigger|
    trigger.name = "Cleanup operation"
    trigger.ruby do
      # the following loop is now obsolete as these files will be removed automatically as machine dependency
      local_disks.each do |local_disk|
        local_disk_filename = File.join(disks_directory, "#{local_disk[:filename]}.vdi")
        if File.exist?(local_disk_filename)
          puts "Deleting \"#{local_disk[:filename]}\" disk"
          system("vboxmanage closemedium disk #{local_disk_filename} --delete")
        end
      end
      if File.exist?(disks_directory)
        FileUtils.rmdir(disks_directory)
      end
    end
  end

  MACHINES.each do |boxname, boxconfig|
    # Disable shared folders
    config.vm.synced_folder ".", "/vagrant", disabled: true
    # add disks
    # Apply VM config
    config.vm.define boxname do |box|
      # Set VM base box and hostname
      box.vm.box = boxconfig[:box_name]
      box.vm.host_name = boxname.to_s
      # Additional network config if present
      if boxconfig.key?(:net)
        boxconfig[:net].each do |ipconf|
          box.vm.network "private_network", ipconf
        end
      end
      # Port-forward config if present
      if boxconfig.key?(:forwarded_port)
        boxconfig[:forwarded_port].each do |port|
          box.vm.network "forwarded_port", port
        end
      end
      # VM resources config
      box.vm.provider "virtualbox" do |v|
        # Set VM RAM size and CPU count
        v.memory = boxconfig[:memory]
        v.cpus = boxconfig[:cpus]
      end
    end
  end
end
