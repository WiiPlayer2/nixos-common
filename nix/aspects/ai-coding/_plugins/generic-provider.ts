// loosely based on https://github.com/goniz/opencode-local-provider/tree/main
// import { z } from "zod"
import { Plugin } from "@opencode/plugin";

const BASE_URL = "http://localhost:5000/v1"

// const ModelsResponseSchema = z.object({
//   data: z
//     .array(
//       z.object({
//         id: z.string(),
//         owned_by: z.string().optional(),
//         name: z.string().optional(),
//         context_length: z.nullish(z.number()),
//       }),
//     )
//     .optional(),
// })

async function probeModels(baseUrl: string) {
  console.log(`probing models...`)
  const res = await fetch(baseUrl + "/models", {
    signal: AbortSignal.timeout(30000),
  })
  if (!res.ok) throw new Error(`generic provider probe failed: ${res.status}`)

  console.log(`parsing models...`)
  // const body = ModelsResponseSchema.parse(await res.json())
  // if (!body.data) throw new Error("generic provider probe failed: no data field")
  const body = await res.json()

  console.log(`mapping models...`)
  return Array.from(await Promise.all(body.data.map(async (item) => {
    const model = {
      enabled: true,
      id: item.id,
      modelID: item.id,
      name: item.name ?? item.id,

      // TODO
      time: {
        released: 1,
        number: 1,
      },
      capabilities: {
        tools: true,
        input: [ "text" ],
        output: [ "text" ],
      },
      variants: [],
      cost: [],
      status: "active",
    }

    console.log(`${JSON.stringify(item)}`)

    if (item.context_length) {
      model["limit"] = {
        context: item.context_length,
        output: item.context_length,
      }
    } else {
      model["limit"] = {
        context: 64000,
        output: 64000,
      }
    }

    return model
  })))
}

export default Plugin.define({
  id: "generic-provider",
  async setup(ctx) {
    console.log("Generic provider plugin loaded.")

    const source = { models: [] }

    await ctx.provider.transform((editor) => {
      editor.update("generic", async (provider) => {
        const providerOptions = provider.options ?? {}
        const baseUrl = BASE_URL

        provider.name = "Generic Provider"
        provider.package = "@opencode/ai/providers/openai-compatible"
        provider.options = {
          ...providerOptions,
          baseURL: baseUrl,
        }
      })

      editor.models.set("generic", source.models)

      console.log(`Generic provider configuration loaded: ${JSON.stringify(editor.get("generic"))}`)
    })

    const firstRefresh = async () => {
      timer = setInterval(() => void refresh().catch(console.error), 300_000) // 5 min
      await refresh()
    }

    const refresh = async () => {
      source.models = await probeModels(BASE_URL)
      await ctx.provider.reload()
    }

    let timer = setTimeout(() => void firstRefresh().catch(console.error), 0)
    return () => clearTimeout(timer)
  },
});
