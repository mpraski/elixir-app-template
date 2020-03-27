%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["apps/"],
        excluded: []
      },
      checks: [
        {Credo.Check.Refactor.MapInto, false},
        {Credo.Check.Warning.LazyLogging, false},
        {Credo.Check.Design.AliasUsage, false}
      ]
    }
  ]
}
