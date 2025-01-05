import ReactDOM from "react-dom/client";
import App from "./app.tsx";
import "./assets/css/index.css";

const container = document.getElementById("root") as HTMLElement;
if (!container) throw new Error("root container missing in index.html");
const root = ReactDOM.createRoot(container);
root.render(<App />);
