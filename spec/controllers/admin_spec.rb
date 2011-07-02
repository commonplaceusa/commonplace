require 'spec_helper'
require 'benchmark'

describe AdminController do
  describe 'performance', :performance => true do
    it 'takes time' do
      Benchmark.realtime {
        get :overview
      }.should < 30
    end

    it 'resolves' do
      get :overview
    end
  end
end
