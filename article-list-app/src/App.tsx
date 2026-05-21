import { Content, Grid, Column, Theme } from "@carbon/react";
import SimpleArticleList from "./components/SimpleArticleList";

function App() {
  return (
    <Theme theme="white">
      <Content>
        <Grid fullWidth>
          <Column sm={4} md={8} lg={16}>
            <h1 style={{ margin: "2rem 0 1rem" }}>Gestion de articulos</h1>
            <SimpleArticleList />
          </Column>
        </Grid>
      </Content>
    </Theme>
  );
}

export default App;
