# encoding: utf-8

class Myaso::AllYourBaseAreBelongToUs
  include Myaso::Client

  class Prefixes < Myaso::Adapter; end
  class Stems < Myaso::Adapter; end
  class Rules < Myaso::Adapter; end
  class Words < Myaso::Adapter; end
end
