# Template output: source tree lives in ./_agents-project (an independent
# flake; the underscore prefix keeps it out of import-tree discovery).
{ ... }:
{
  flake.templates.agents-project = {
    path = ./_agents-project;
    description = "Agents based software engineering project";
  };
}
