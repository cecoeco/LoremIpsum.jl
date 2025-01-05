import React, { useState } from "react";
import Header from "./components/header.tsx";
import Footer from "./components/footer.tsx";

const App: React.FunctionComponent = () => {
  const [text, setText] = useState("");
  const [random, setRandom] = useState(false);
  const [length, setLength] = useState(100);

  const generateLoremIpsum = async () => {
    const response = await fetch(`/api/${random}/${length}`);
    const data = await response.text();
    setText(data);
  };

  return (
    <React.StrictMode>
      <Header />
      <main>
        <div className="lorem-ipsum-container">
          <label>
            Length:
            <input
              type="number"
              className="lorem-ipsum-length"
              value={length}
              onChange={(e) => setLength(Number(e.target.value))}
            />
          </label>
          <label>
            Random:
            <input
              type="checkbox"
              checked={random}
              onChange={(e) => setRandom(e.target.checked)}
            />
          </label>
          <button onClick={generateLoremIpsum}>Generate</button>
          <div className="lorem-ipsum-text">{text}</div>
        </div>
      </main>
      <Footer />
    </React.StrictMode>
  );
};

export default App;
