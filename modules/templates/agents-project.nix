# Template output: source tree lives in templates/agents-project (an independent
# flake, outside root module discovery).
{ ... }:
{
  flake.templates.agents-project = {
    path = ../../templates/agents-project;
    description = "Agents based software engineering project";
  };
}
