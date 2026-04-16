import { Hono } from "hono";
import { publicController } from "../controllers/public.controller";
import { whatsappController } from "../controllers/whatsapp.controller";

const publicRoutes = new Hono();

// Send Message Group / Chat
publicRoutes.post("/send-message-global", (c) =>
    publicController.sendMessageGlobal(c)
);

// Send Message Chat
publicRoutes.post("/send-message", (c) =>
    whatsappController.sendMessage(c)
);

// Send Message Group
publicRoutes.post("/send-message-group", (c) =>
    whatsappController.sendMessage(c)
);

// Send Media Url Group / Chat
publicRoutes.post("/send-media-url", (c) =>
    whatsappController.sendMediaWithUrl(c)
);

export default publicRoutes;