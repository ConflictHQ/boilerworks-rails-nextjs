import { redirect } from "next/navigation";
import { cookies } from "next/headers";

export default async function RootPage() {
  const cookieStore = await cookies();
  const hasSession = cookieStore.has("session_id");

  if (hasSession) {
    redirect("/dashboard");
  } else {
    redirect("/auth/login");
  }
}
