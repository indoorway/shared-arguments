require 'graphql'
require 'graphql/shared_arguments/version'
require 'graphql/shared_arguments/injector'
require 'graphql/shared_arguments/define/assign_shared_arguments'

GraphQL::ObjectType.accepts_definitions(shared_arguments: GraphQL::SharedArguments::Define::AssignSharedArguments)

module GraphQL
  class SharedArguments
    include ::GraphQL::Define::InstanceDefinable

    accepts_definitions :arguments,
                        :filter,
                        argument: ::GraphQL::Define::AssignArgument

    ensure_defined :arguments, :filter
    attr_accessor :arguments, :filter

    def use(_schema_definition); end

    def initialize
      @filter = nil
      @arguments = {}
    end
  end
end
