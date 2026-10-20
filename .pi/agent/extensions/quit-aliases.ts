import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const QUIT_ALIASES = new Set([":q", ":qa", ":x"]);

export default function (pi: ExtensionAPI) {
	pi.on("input", (event, ctx) => {
		if (event.source === "extension") {
			return { action: "continue" };
		}

		if (!QUIT_ALIASES.has(event.text.trim().toLowerCase())) {
			return { action: "continue" };
		}

		ctx.shutdown();
		return { action: "handled" };
	});
}
