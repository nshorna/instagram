import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/user_data.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
import 'package:instagram_clone/screens/edit_profile_screen.dart';
import 'package:instagram_clone/services/auth_service.dart';
import 'package:instagram_clone/services/database_service.dart';
import 'package:instagram_clone/utilities/consts.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/widgets/post_view.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();

  final String userId;
  final String currentUserId;

  ProfileScreen({this.userId, this.currentUserId});
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isFollowing = false;
  int _followerCount = 0;
  int _followingCount = 0;
  List<Post> _posts = [];
  int _displayPosts = 0; //0 - grid, 1 - column
  User _profileUser;

  @override
  void initState() {
    super.initState();
    _setupIsFollowing();
    _setupFollowing();
    _setupFollowers();
    _setupPosts();
    _setupProfileUser();
  }

  _followOrUnfollow() {
    if (_isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  _unfollowUser() {
    DatabaseService.unfollowUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    if (this.mounted) {
      setState(() {
        _isFollowing = false;
        _followerCount--;
      });
    }
  }

  _followUser() {
    DatabaseService.followUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    if (this.mounted) {
      setState(() {
        _isFollowing = true;
        _followerCount++;
      });
    }
  }

  _setupIsFollowing() async {
    bool isFollowingUser = await DatabaseService.isFollowingUser(
        currentUserId: widget.currentUserId, userId: widget.userId);
    print('Isfollowing: $isFollowingUser');
    if (this.mounted) {
      setState(() {
        _isFollowing = isFollowingUser;
      });
    }
  }

  _setupFollowers() async {
    int userFollowersCount = await DatabaseService.numFollowers(widget.userId);
    print('User Followers Count: $userFollowersCount');
    if (this.mounted) {
      setState(() {
        _followerCount = userFollowersCount;
      });
    }
  }

  _setupFollowing() async {
    int userFollowingCount = await DatabaseService.numFollowing(widget.userId);
    print('User following count: $userFollowingCount');
    if (this.mounted) {
      setState(() {
        _followingCount = userFollowingCount;
      });
    }
  }

  _setupPosts() async {
    List<Post> posts = await DatabaseService.getUserPosts(widget.userId);
    setState(() {
      _posts = posts;
    });
  }

  _setupProfileUser() async {
    User profileUser = await DatabaseService.getUserWithId(widget.userId);
    setState(() {
      _profileUser = profileUser;
    });
  }

  _displayButton(User user) {
    return user.id == Provider.of<UserData>(context).currentUserId
        ? Container(
            child: FlatButton(
              child: Text(
                'Edit Profile',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EditProfileScreen(
                            user: user,
                          ))),
            ),
            width: 200,
          )
        : Container(
            child: FlatButton(
              child: Text(
                _isFollowing ? 'Unfollow' : 'Follow',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
              color: _isFollowing ? Colors.grey[200] : Colors.blue,
              textColor: _isFollowing ? Colors.black : Colors.white,
              onPressed: _followOrUnfollow,
            ),
            width: 200,
          );
  }

  _buildProfileInfo(User user) {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 50,
                backgroundImage: user.profileImageUrl.isEmpty
                    ? AssetImage('assets/images/user_placeholder.png')
                    : CachedNetworkImageProvider(user.profileImageUrl)),
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            _posts.length.toString(),
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'posts',
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            _followerCount.toString(),
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'followers',
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            _followingCount.toString(),
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'following',
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  _displayButton(user),
                ],
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
        child: Column(
          children: <Widget>[
            Text(
              user.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              child: Text(
                user.bio,
                style: TextStyle(fontSize: 15.0),
              ),
              height: 80.0,
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      )
    ]);
  }

  _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on),
          iconSize: 30.0,
          color: _displayPosts == 0
              ? Theme.of(context).primaryColor
              : Colors.grey[300],
          onPressed: () {
            setState(() {
              _displayPosts = 0;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.list),
          iconSize: 30.0,
          color: _displayPosts == 1
              ? Theme.of(context).primaryColor
              : Colors.grey[300],
          onPressed: () {
            setState(() {
              _displayPosts = 1;
            });
          },
        ),
      ],
    );
  }

  _buildTilePost(Post post) {
    return GridTile(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CommentsScreen(
              post: post,
              likeCount: post.likeCount,
            ),
          ),
        ),
        child: Image(
          image: CachedNetworkImageProvider(post.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  _buildDisplayPosts() {
    if (_displayPosts == 0) {
      //Grid view
      List<GridTile> tiles = [];
      _posts.forEach((post) => tiles.add(_buildTilePost(post)));
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        shrinkWrap: true,
        children: tiles,
        physics: NeverScrollableScrollPhysics(),
      );
    } else {
      //Column
      List<PostView> postViews = [];
      _posts.forEach((post) {
        postViews.add(PostView(
          currentUserId: widget.currentUserId,
          post: post,
          author: _profileUser,
        ));
      });

      return Column(children: postViews);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Instagram',
            style: TextStyle(
              fontFamily: 'Billabong',
              fontSize: 35.0,
              color: Colors.black,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => AuthService.logout(),
          )
        ],
      ),
      body: FutureBuilder(
        future: usersRef.document(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          User user = User.fromDoc(snapshot.data);

          return ListView(
            children: <Widget>[
              _buildProfileInfo(user),
              _buildToggleButtons(),
              Divider(),
              _buildDisplayPosts(),
            ],
          );
        },
      ),
    );
  }
}
