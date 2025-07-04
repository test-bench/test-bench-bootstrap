module TestBenchBootstrap
  def self.activate
    TestBenchBootstrap::TestBench.activate
  end

  Run = TestBenchBootstrap::TestBench::Run
end
