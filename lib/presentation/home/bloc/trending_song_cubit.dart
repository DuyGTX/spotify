import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spotify/domain/usecases/song/get_trending.dart';
import 'package:spotify/presentation/home/bloc/trending_song_state.dart';

class TrendingSongCubit extends Cubit<TrendingSongState> {
  final GetTrendingSongUseCase useCase;

  TrendingSongCubit(this.useCase) : super(TrendingSongLoading());

  Future<void> getTrendingSongs() async {
    final result = await useCase.call(); // ✅ không cần truyền params
    result.fold(
      (l) => emit(TrendingSongLoadFailure()),
      (r) => emit(TrendingSongLoaded(songs: r)),
    );
  }
}
