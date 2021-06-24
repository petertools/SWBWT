import CSI 1.0
import QtQuick 2.0

// Use codebird to wrap Twitter API
import "codebird.js" as CB

Module
{
  id: tweet_a_deck
  property int deckIndex: 1

  // Observe Deck's Artist, Title and Label properties
  AppProperty { id: artist;         path: "app.traktor.decks." + deckIndex + ".content.artist" }
  AppProperty { id: title;          path: "app.traktor.decks." + deckIndex + ".content.title"  }
  AppProperty { id: label;          path: "app.traktor.decks." + deckIndex + ".content.label"  }

  // Listen to Deck's loaded signal
  AppProperty { path: "app.traktor.decks." + deckIndex + ".is_loaded_signal"; onValueChanged: loadedTimer.restart(); }

  // Import the Twitter API keys
  TwitterConfig { id: config }

  Timer
  {
    id: loadedTimer

    interval: 1000  // milliseconds
    repeat: false

    onTriggered:
    {
      if (artist.value != "" && title.value != "")
      {
        // Create a codebird instance
        var cb = new CB.Fcodebird;
        cb.setUseProxy(false);

        // Configure API keys and token
        cb.setToken(config.token, config.token_secret);
        cb.setConsumerKey(config.api_key, config.api_secret);

        // Tweet the Track ID!
        cb.__call("statuses_update", { status: "Now playing: " + artist.value + " - " + title.value + " (" + label.value + ")" },
                  function( reply, rate, err) {});
      }
    }
  }

} // Module
