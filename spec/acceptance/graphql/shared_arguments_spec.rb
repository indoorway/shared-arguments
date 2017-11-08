require 'spec_helper'

describe 'shared_arguments in schema' do
  let!(:base_query_type) do
    QueryType = GraphQL::ObjectType.define do
      name 'Query'
      field :banana, types.String
      field :apple, types.String
      field :orange, types.String
    end
  end

  let!(:schema) do
    GraphQL::Schema.define do
      query(QueryType)
      use GraphQL::SharedArguments.new
    end
  end

  after { Object.send(:remove_const, :QueryType) }

  describe 'inclusion in schema' do
    context 'when applying to all' do
      before do
        tmp_def = QueryType.redefine do
          shared_arguments do
            argument :seeds_amount, types.Int
          end
        end
        Object.send(:remove_const, :QueryType)
        QueryType = tmp_def
      end

      it 'defines extra argument to all fields' do
        schema.get_fields(QueryType)
        expect(schema.get_fields(QueryType)).to match(
          'banana' => have_attributes(arguments: { 'seeds_amount' => be_instance_of(GraphQL::Argument) }),
          'apple' => have_attributes(arguments: { 'seeds_amount' => be_instance_of(GraphQL::Argument) }),
          'orange' => have_attributes(arguments: { 'seeds_amount' => be_instance_of(GraphQL::Argument) })
        )
      end
    end

    context 'when using except on banana, apple' do
      before do
        tmp_def = QueryType.redefine do
          shared_arguments except: %i(banana apple) do
            argument :seeds_amount, types.Int
          end
        end
        Object.send(:remove_const, :QueryType)
        QueryType = tmp_def
      end

      it 'defines extra argument to orange' do
        expect(schema.get_fields(QueryType)).to match(
          'banana' => be_instance_of(GraphQL::Field),
          'apple' => be_instance_of(GraphQL::Field),
          'orange' => have_attributes(arguments: { 'seeds_amount' => be_instance_of(GraphQL::Argument) })
        )
      end

      it 'does not define extra argument to banana and apple' do
        expect(schema.get_fields(QueryType)).to_not match(
          'orange' => be_instance_of(GraphQL::Field),
          'banana' => have_attributes(arguments: { 'seeds_amount' => be_instance_of(GraphQL::Argument) }),
          'apple' => have_attributes(arguments: { 'seeds_amount' => be_instance_of(GraphQL::Argument) })
        )
      end
    end

    context 'when using only on orange, apple' do
      before do
        tmp_def = QueryType.redefine do
          shared_arguments only: %i(orange apple) do
            argument :seeds_amount, types.Int
          end
        end
        Object.send(:remove_const, :QueryType)
        QueryType = tmp_def
      end

      it 'defines extra argument to orange and apple' do
        expect(schema.get_fields(QueryType)).to match(
          'banana' => be_instance_of(GraphQL::Field),
          'apple' => have_attributes(arguments: { 'seeds_amount' => be_instance_of(GraphQL::Argument) }),
          'orange' => have_attributes(arguments: { 'seeds_amount' => be_instance_of(GraphQL::Argument) })
        )
      end

      it 'does not define extra argument to banana' do
        expect(schema.get_fields(QueryType)).to_not match(
          'banana' => have_attributes(arguments: { 'seeds_amount' => be_instance_of(GraphQL::Argument) }),
          'apple' => be_instance_of(GraphQL::Field),
          'orange' => be_instance_of(GraphQL::Field)
        )
      end
    end
  end
end
