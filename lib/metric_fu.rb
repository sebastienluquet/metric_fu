# Load a few things to make our lives easier elsewhere.
module MetricFu
  LIB_ROOT = File.dirname(__FILE__)
  [:churn, :flog, :flay, :reek, :roodi, :saikuro].each do |metric|
    instance_eval <<-EOF
      def generate_#{metric}_report
        report.add(:#{metric})
        report.save_templatized_report
      end
    EOF
  end
end
base_dir = File.join(MetricFu::LIB_ROOT, 'base')
generator_dir = File.join(MetricFu::LIB_ROOT, 'generators')
template_dir  = File.join(MetricFu::LIB_ROOT, 'templates')
graph_dir     = File.join(MetricFu::LIB_ROOT, 'graphs')

# We need to require these two things first because our other classes
# depend on them.
require File.join(base_dir, 'report') 
require File.join(base_dir, 'generator')
require File.join(base_dir, 'graph')

# Load the rakefile so users of the gem get the default metric_fu task
load File.join(MetricFu::LIB_ROOT, '..', 'tasks', 'metric_fu.rake')

# Now load everything else that's in the directory
Dir[File.join(base_dir, '*.rb')].each{|l| require l }
Dir[File.join(generator_dir, '*.rb')].each {|l| require l }
Dir[File.join(template_dir, 'standard/*.rb')].each {|l| require l}
Dir[File.join(template_dir, 'awesome/*.rb')].each {|l| require l}
Dir[File.join(graph_dir, '*.rb')].each {|l| require l}