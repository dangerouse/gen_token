GenToken
--------

GenToken is an ActiveRecord specific extension that will generate a
unique value in a particular field for your model. It's useful to
adding a publicly visible key to your model when simply hashing won't do
For security purposes a hash may not be adequate since it is generated from
the

Usage
-----

    class MyModel < ActiveRecord::Base
      attr_accessor :token
      include GenToken
      gen_token :token
    end

Easy. 