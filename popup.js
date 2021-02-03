
document.addEventListener('DOMContentLoaded', function() {
    var checkPageButton = document.getElementById('checkPage');
    
    checkPageButton.addEventListener('click', function() {
      var matchIdText = document.getElementById('matchId').value;
      var matchRegex = new RegExp(/[0-9]{10}/);
      var goodMatchId = matchRegex.test(matchIdText);
      console.log(matchIdText);
      console.log(goodMatchId);
      if (matchIdText != null && goodMatchId){
        fetch('https://api.opendota.com/api/matches/' + matchIdText)
        .then(response => response.json())
        .then(
          data => chrome.downloads.download({url: data.replay_url, filename: matchIdText + ".dem.bz2"}) //F:/SteamLibrary/steamapps/common/dota 2 beta/game/dota/replays/
        );
      }
    }, false);
  }, false);
