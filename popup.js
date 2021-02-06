var commandtoRun = "powershell.exe -ExecutionPolicy Bypass -File ./unzip_move_run.ps1"; 

document.addEventListener('DOMContentLoaded', function() {
    var checkPageButton = document.getElementById('checkPage');
    var loadingBar = document.getElementById('loadingBar');
    
    checkPageButton.addEventListener('click', function() {
        var matchIdText = document.getElementById('matchId').value;
        var matchRegex = new RegExp(/[0-9]{10}/);
        var goodMatchId = matchRegex.test(matchIdText);
        console.log(matchIdText);
        console.log(goodMatchId);
        checkPageButton.disabled = true;
        loadingBar.style.display = "block";
        if (matchIdText != null && goodMatchId) {
            console.log(`button disabled: ${checkPageButton.disabled}`)
            fetch('https://api.opendota.com/api/matches/' + matchIdText)
            .then(response => response.json())
            .then(
                data => {
                    chrome.downloads.download({url: data.replay_url, filename: matchIdText + ".dem.bz2"}) //F:/SteamLibrary/steamapps/common/dota 2 beta/game/dota/replays/
                    checkPageButton.disabled = false;
                    loadingBar.style.display = "none";
                });
                chrome.runtime.sendNativeMessage('com.skewjo.dota_match_finder',
        { args: "dir" });
        }
    }, false);
}, false);
