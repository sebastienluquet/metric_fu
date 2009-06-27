begin

  def flog(output, directory)
    metric_dir = MetricFu::Flog::Generator.metric_dir
    Dir.glob("#{directory}/**/*.rb").each do |filename|
      output_dir = "#{metric_dir}/#{filename.split("/")[0..-2].join("/")}"
      mkdir_p(output_dir, :verbose => false) unless File.directory?(output_dir)
      if MetricFu::MD5Tracker.file_changed?(filename, metric_dir)
        `flog #{filename} > #{metric_dir}/#{filename.split('.')[0]}.txt`
      end
    end
  end

  namespace :metrics do

    task :flog => ['flog:all'] do
    end

    namespace :flog do
      desc "Delete aggregate flog data."
      task(:clean) { rm_rf(MetricFu::Flog.metric_directory, :verbose => false) }

      desc "Flog code in app/models"
      task :models do
        MetricFu.configuration.flog     = { :dirs_to_flog => ['app/models'] }
        MetricFu.generate_flog_report
      end

      desc "Flog code in app/controllers"
      task :controllers do
        MetricFu.configuration.flog     = { :dirs_to_flog => ['app/controllers'] }
        MetricFu.generate_flog_report
      end

      desc "Flog code in app/helpers"
      task :helpers do
        MetricFu.configuration.flog     = { :dirs_to_flog => ['app/helpers'] }
        MetricFu.generate_flog_report
      end

      desc "Flog code in lib"
      task :lib do
        MetricFu.configuration.flog     = { :dirs_to_flog => ['lib'] }
        MetricFu.generate_flog_report
      end

      desc "Generate a flog report from specified directories"
      task :custom do
        MetricFu.generate_flog_report
      end

      desc "Generate and open flog report"
      if MetricFu.configuration.rails?
        task :all do
          MetricFu.configuration.flog     = { :dirs_to_flog => ['app', 'lib'] }
          MetricFu.generate_flog_report
        end
      else
        task :all => [:custom] do
        end
      end

    end

  end
rescue LoadError
  if RUBY_PLATFORM =~ /java/
    puts 'running in jruby - flog tasks not available'
  else
    puts 'sudo gem install flog # if you want the flog tasks'
  end
end