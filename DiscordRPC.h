#include <Windows.h>
#include <discord_rpc.h>

class DiscordRPC
{
public:
	DiscordRPC();
	~DiscordRPC();

	VOID Initialise(const char *AppId);
	BOOL Update(DiscordRichPresence *richPresence);
	VOID UpdateRP(DiscordRichPresence *richPresence);
	BOOL FastUpdate();
	VOID ClearPresence();
private:
	VOID Shutdown();

	DiscordRichPresence rich;
	bool b_init;
};