require 'assert'
require 'cap-util/timer'

class CapUtil::Timer

  class UnitTests < Assert::Context
    desc "CapUtil::Timer"
    setup do
      @timer_util = CapUtil::Timer.new('a timer', :quiet)
    end
    subject{ @timer_util }

    should have_readers :name, :start_time, :end_time, :elapsed_time
    should have_imeths  :start, :end
    should have_cmeth   :pretty_time

    should "know its name" do
      assert_equal 'a timer', subject.name
    end

    should "default its start, end, and elapsed times" do
      assert_equal 0, subject.start_time
      assert_equal 0, subject.end_time
      assert_equal 0, subject.elapsed_time
    end

    should "record its start time on `start`" do
      exp_start_time = ::Time.now
      subject.start(exp_start_time)

      assert_equal exp_start_time, subject.start_time
    end

    should "record its end and elapsed time on `end`" do
      exp_start_time = ::Time.now
      subject.start(exp_start_time)
      sleep 1
      exp_end_time = ::Time.now
      subject.end(exp_end_time)

      assert_equal exp_end_time, subject.end_time
      assert_equal (exp_end_time - exp_start_time), subject.elapsed_time
      assert_equal "0:01", CapUtil::Timer.pretty_time(subject.elapsed_time.to_i)
    end

  end

end
