Raw API endpoint:
  - http://e16571:8013/v1
GUI:
  - http://e16571:3000
Model: 
  - openai/gpt-oss-120b


## Set up openhands with SDL-model
```
The "SDL" Provider Connection
    Name: SDL
    Provider: OpenAI
    API Key: sk-979e4adf3565455ea5d96d802e783ce9
    Base URL: http://172.31.19.55:3000/api/v1

The "Gemma-4-31b" LLM Profile
    Profile Name: Gemma-4-31b
    Authentication: API key
    Custom Model: openai/gemma-4-31b
    Provider connection: SDL
    Temperature: 0.2
```
**Important** Turn temperature down low: 0.1-0.2
Too high causes the complexity budge to explode and gets rejected by the server
Too low causes the model to get stuck in looped nonsense


### Temp configs to get around agent loop not seeing api key:
```
incus config set openhands environment.OPENAI_API_KEY=sk-979e4adf3565455ea5d96d802e783ce9
incus config set openhands environment.OPENAI_API_BASE=http://172.31.19.55:3000/api
```












Software Training Alternative
  https://app.pluralsight.com/id


"I believe you can borrow from a 403b up to 50k or 50% (whichever's lesser) for help buying a house. I can't remember if you have to pay taxes on it if you repay the *loan*, though. You'll have to do your own research."
