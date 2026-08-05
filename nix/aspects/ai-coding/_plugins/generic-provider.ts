// based on https://github.com/goniz/opencode-local-provider/tree/main
import { z } from "zod"

const ModelsResponseSchema = z.object({
  data: z
    .array(
      z.object({
        id: z.string(),
        // owned_by: z.string().optional(),
      }),
    )
    .optional(),
})

async function probeModels() {
  const res = await fetch("http://localhost:5000/v1/models", {
    signal: AbortSignal.timeout(1000),
  })
  if (!res.ok) throw new Error(`generic provider probe failed: ${res.status}`)
  const body = ModelsResponseSchema.parse(await res.json())
  if (!body.data) throw new Error("generic provider probe failed: no data field")

  return Object.fromEntries(body.data.map((item) => [item.id, {
    name: item.id,
  }]))
}

export const GenericProviderPlugin = async (ctx) => {
  await ctx.client.app.log({
    body: {
      service: "generic-provider",
      level: "info",
      message: "Generic provider plugin loaded.",
    },
  })

  return {
    config: async (cfg) => {
      cfg.provider ??= {}
      const provider = cfg.provider["generic"] ?? {}
      // TODO: use configured upstream url(s)
      cfg.provider["generic"] = {
        ...provider,
        name: provider.name ?? "Generic Provider",
        npm: provider.npm ?? "@ai-sdk/openai-compatible",
        models: await probeModels(ctx),
        options: {
          baseURL: "http://localhost:5000/v1"
        }
      }
    },
  }
}
