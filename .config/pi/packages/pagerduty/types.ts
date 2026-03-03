import type { TObject } from "@sinclair/typebox";

export interface ToolDef {
  name: string;
  label: string;
  description: string;
  parameters: TObject;
  execute: (
    toolCallId: string,
    params: any,
    signal?: AbortSignal,
    onUpdate?: any,
    ctx?: any
  ) => Promise<{ content: Array<{ type: string; text: string }> }>;
}
