{ ... }:
{
  programs.codex = {
    enable = true;
    settings = {
      model = "gpt-5.6-sol";
      model_reasoning_effort = "xhigh";
      model_provider = "jcg";
      model_providers = {
        jcg = {
          name = "OpenAI";
          base_url = "https://ai-pixel.online/v1";
          env_key = "OPENAI_API_KEY";
        };
      };
      sandbox_mode = "workspace-write";
      approval_policy = "on-request";
    };
  };
}
