// - This Edge function makes use of Firebase Cloud Messaging to deliver push notification to registered devices.
// - You need a service acccount and a Firebase project setup with Cloud messaging enabled.
// - Supabase secrets are available to edge functions by default so no intervention is required to push secrets.
// - I have added and handled cors headers incase the function is invoked from a browser/web app


import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.3";
import { JWT } from "npm:google-auth-library@9";
import { corsHeaders } from "../_shared/cors.ts";
import serviceAccount from "../service-account.json" with { type: "json" };

const supabase = createClient(
  Deno.env.get("SUPABASE_URL") as string,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") as string
);

const getAccessToken = ({
  clientEmail,
  privateKey,
}: {
  clientEmail: string;
  privateKey: string;
}): Promise<string> => {
  return new Promise((resolve, reject) => {
    const jwtClient = new JWT({
      email: clientEmail,
      key: privateKey,
      scopes: ["https://www.googleapis.com/auth/firebase.messaging"],
    });
    jwtClient.authorize((err, tokens) => {
      if (err) {
        reject(err);
        return;
      }
      resolve(tokens!.access_token!);
    });
  });
};

const accessToken = await getAccessToken({
  clientEmail: serviceAccount.client_email,
  privateKey: serviceAccount.private_key,
});

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method === "POST") {
    const { user_id, body } = await req.json();
    const { data, error } = await supabase
      .from("users")
      .select("fcm_token")
      .eq("id", user_id)
      .single();

    if (error) {
      console.error("Supabase error:", error);
      return new Response("Internal Server Error", {
        status: 500,
        headers: corsHeaders,
      });
    }

    const fcmToken = data!.fcm_token as string;
    const res = await fetch(
      `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify({
          message: {
            token: fcmToken,
            notification: body,
          },
        }),
      }
    );
    const resData = await res.json();
    if (res.status < 200 || 299 < res.status) {
      throw resData;
    }

    return new Response(JSON.stringify(resData), {
      headers: { "Content-Type": "application/json" , ...corsHeaders},
    });
  }

  return new Response("Invalid Request", {
    status: 400,
    headers: corsHeaders,
  });
});
