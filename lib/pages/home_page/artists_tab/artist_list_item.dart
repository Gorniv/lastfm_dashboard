import 'package:flutter/material.dart';
import 'package:lastfm_dashboard/bloc.dart';
import 'package:lastfm_dashboard/events/artitsts_events.dart';
import 'package:lastfm_dashboard/models/models.dart';
import 'package:provider/provider.dart';

class ArtistListItem extends StatelessWidget {
  final bool drawSelectionCircle;
  final ArtistSelection selection;
  final UserArtistDetails artistDetails;

  static const _colors = <Color>[
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.yellow,
  ];

  const ArtistListItem({
    this.selection,
    this.artistDetails,
    this.drawSelectionCircle = true,
  });

  void addSelection(BuildContext context, String artistId, Color color) {
    Provider.of<EventsContext>(context, listen: false).push(
      SelectArtistEventInfo(artistId: artistId, selectionColor: color),
      selectArtist,
    );
  }

  void removeSelection(BuildContext context, String artistId) {
    Provider.of<EventsContext>(context, listen: false).push(
      RemoveArtistSelectionEventInfo(artistId: artistId),
      removeArtistSelection,
    );
  }

  @override
  Widget build(BuildContext context) {
    final image = artistDetails.imageInfo.small;
    return FlatButton(
      onPressed: () {
        final selectedColor = selection?.selectionColor;
        final currentColorIndex = selectedColor == null
            ? -1
            : _colors.indexWhere((c) => c.value == selectedColor.value);
        final color = _colors[(currentColorIndex + 1) % _colors.length];
        addSelection(context, artistDetails.artistId, color);
      },
      padding: EdgeInsets.all(0),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: <Widget>[
            Container(
              color: selection?.selectionColor,
              height: 44,
              width: 2,
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: drawSelectionCircle ? selection?.selectionColor : null,
              ),
              height: 46,
              width: 46,
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          image != null ? NetworkImage(image) : null,
                    ),
                  ),
                  if (selection?.selectionColor != null && drawSelectionCircle)
                    Center(
                      child: Icon(
                        Icons.check,
                        color: selection?.selectionColor,
                        size: 40,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    artistDetails.name,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    '${artistDetails.scrobbles} scrobbles',
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            ),
            if (selection?.selectionColor != null) ...[
              IconButton(
                icon: Icon(Icons.color_lens),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () =>
                    removeSelection(context, artistDetails.artistId),
              ),
            ],
            SizedBox(
              width: 12,
            ),
          ],
        ),
      ),
    );
  }
}
