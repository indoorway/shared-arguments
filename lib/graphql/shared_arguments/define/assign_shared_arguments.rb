module GraphQL
  class SharedArguments
    module Define
      module AssignSharedArguments
        def self.call(target, filter = {}, &block)
          shared = GraphQL::SharedArguments.define(filter: filter, &block)
          shared.define
          GraphQL::SharedArguments::Injector.new(target, filter, shared.arguments).inject
        end
      end
    end
  end
end
