#include <apiPlugin.h>
#include "IUnknownInterfaceImpl.h"

class AIMPPlugin : public IUnknownInterfaceImpl<IAIMPPlugin>
{
public:
	AIMPPlugin();
	~AIMPPlugin();

	static VOID UpdatePlayerState(INT AIMPRemote_State);
	static VOID UpdateTrackInfo(PAIMPTrackInfo AIMPRemote_TrackInfo);

	PWCHAR WINAPI InfoGet(INT Index);
	DWORD WINAPI InfoGetCategories();

	HRESULT WINAPI Initialize(IAIMPCore* Core);
	HRESULT WINAPI Finalize();

	VOID WINAPI SystemNotification(INT NotifyID, IUnknown* Data);
private:
	bool bFinalised;
};