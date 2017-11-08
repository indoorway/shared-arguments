# shared_arguments
Ruby gem for GraphQL arguments sharing within fields

Sometimes you want to use the same arguments for multiple fields in custom object type.
To avoid repeating those declarations and DRY-up your schema, I introduce you shared_arguments field.

This gem is mostly usable when you have:
 - many fields with few repeating arguments in each field
 - few fields with many repeating arguments in each field
 - many fields with many repeating arguments in each field

## Example use case

```
graphql/types/analytics_type.rb

Types::AnalyticsType = GraphQL::ObjectType.define do
    name 'Analytics'
    
    field :invoices, types.[Types::Invoice] do
       argument :from, !Types::DateType
       argument :to, !Types::DateType
       argument :companyID, types.ID
    end
    
    field :registeredUsers, types.[Types::User] do
       argument :from, !Types::DateType
       argument :to, !Types::DateType
       argument :companyID, types.ID
    end
    
    field :downloadsAmount, types.Int do
       argument :from, !Types::DateType
       argument :to, !Types::DateType
       argument :userAmount, types.ID
    end
end
```

This can be shortened like in below example

```
graphql/types/analytics_type.rb

Types::AnalyticsType = GraphQL::ObjectType.define do
    name 'Analytics'
    
    field :invoices, types.[Types::Invoice]
    
    field :registeredUsers, types.[Types::User]
    
    field :downloadsAmount, types.Int do
       argument :userAmount, types.ID
    end
    
    shared_arguments do
       argument :from, !Types::DateType
       argument :to, !Types::DateType
    end
    
    shared_arguments except: %i(downloadsAmount) do
       argument :companyID, types.ID
    end
end
```
`shared_arguments` field takes both `except` and `only` keyword so you can omit or select specified fields.

Any further contributions are welcomed.

