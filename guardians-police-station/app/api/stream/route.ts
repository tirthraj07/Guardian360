// app/api/stream/route.ts
import clientPromise from "@/lib/mongo";

export async function GET(request: Request) {
  const encoder = new TextEncoder();

  // Create a ReadableStream to send SSE events.
  const stream = new ReadableStream({
    async start(controller) {
      try {
        const client = await clientPromise;
        const db = client.db("guardian360db"); // Replace with your DB name if different
        const collection = db.collection("incident_reports");

        // Set up a change stream on the collection.
        const changeStream = collection.watch([], { fullDocument: "updateLookup" });

        // Send a heartbeat every 30 seconds to keep the connection alive.
        const heartbeatInterval = setInterval(() => {
          controller.enqueue(encoder.encode("data: heartbeat\n\n"));
        }, 30000);

        // When a new document is inserted, send it to the client.
        changeStream.on("change", (change) => {
          if (change.operationType === "insert") {
            const newCase = change.fullDocument;
            controller.enqueue(encoder.encode(`data: ${JSON.stringify(newCase)}\n\n`));
          }
        });

        // If the client aborts the request, clean up resources.
        request.signal.addEventListener("abort", () => {
          clearInterval(heartbeatInterval);
          changeStream.close();
          controller.close();
        });
      } catch (error) {
        controller.error(error);
      }
    }
  });

  // Return a streaming Response with the appropriate SSE headers.
  return new Response(stream, {
    headers: {
      "Content-Type": "text/event-stream",
      "Cache-Control": "no-cache",
      "Connection": "keep-alive",
    },
  });
}
